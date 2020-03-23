class OrderService
    attr_reader :session

    def initialize(session, request)
        @session, @request = session, request
    end
    def test
        final_answer = nil
        if session[:login].nil? || session[:credits] == 0
            final_answer = {"result": false, "error": "401 Unauthorized"}
        else
            client = HTTPClient.new
            response = client.request(:get, 'http://possible_orders.srv.w55.ru/')
            query_to_http = "?#{@request.query_string.split('&os')[0]}"
            vm_price = client.get("http://http_server:5678/#{query_to_http}").http_body.content.split(/[\r\n]/)[0].to_f
            result = JSON.parse(response.body)
            
            normalized_query_params = @request.query_parameters.map{|k,v| v.to_i == 0 ? [k, v] : [k, v.to_i]}.to_h
            machines = result['specs']
            result_of_query = machines.filter{|machine|
                !normalized_query_params.map{|k, v| 
                    if machine[k].is_a?(Hash)
                        hdd_capacity_from_query = normalized_query_params['hdd_capacity']
                        hdd_type_from_query = normalized_query_params['hdd_type']
                        if machine[k][hdd_type_from_query].nil? 
                            puts "#{machine[k][hdd_type_from_query].nil?}"
                            false
                        else
                            machine[k][hdd_type_from_query]['from'] <= hdd_capacity_from_query &&
                            machine[k][hdd_type_from_query]['to'] >= hdd_capacity_from_query ?
                            true : 
                            false
                        end
                    else
                        machine[k].include?(v)
                    end
                }.include?(false)
            }
            balance_after_transaction = session[:credits].to_f - vm_price
            if result_of_query.empty? || balance_after_transaction < 0
                final_answer = {"result": false, "error": "406 Not Acceptable"}
            end
            if final_answer.nil?
                final_answer = {
                    "result": true,
                    "total": "#{vm_price}",
                    "balance": "#{session[:credits]}",
                    "balance_after_transaction": "#{balance_after_transaction}",
                }
            end
            final_answer
            # {
            #     "login":"#{session[:login]}",
            #     "money":"#{session[:credits]}",
            #     "b": "#{balance_after_transaction}",
            #     "result": answer_from_server,
            #     "try": normalized_query_params,
            #     "http": vm_price,
            #     "request": "#{@request.query_string}"
            # }
        end
    end
end

# ?cpu=4&ram=8&hdd_capacity=150&hdd_type=ssd&os=linux