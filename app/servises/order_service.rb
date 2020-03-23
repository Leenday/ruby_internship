class OrderService
    attr_reader :session

    def initialize(session, request)
        @session, @request = session, request
    end
    def test
        if session[:login].nil? || session[:credits] == 0
            {"result": false, "error": "401 Unauthorized"}
        else
            client = HTTPClient.new
            response = client.request(:get, 'http://possible_orders.srv.w55.ru/')
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
            answer_from_server = result_of_query.empty? ? {"result": false, "error": "406 Not Acceptable"} : result_of_query
            {"login":"#{session[:login]}",
            "money":"#{session[:credits]}",
            "result": answer_from_server,
            "try": normalized_query_params}
        end
    end
end

# ?cpu=4&ram=8&hdd_capacity=150&hdd_type=ssd&os=linux

# client = HTTPClient.new
#     response = client.request(:get, 'http://possible_orders.srv.w55.ru/')
#     result = JSON.parse(response.body)
#     render json: result

# class LoginService
#     attr_reader :login, :password, :session
    
#     def initialize(login, password, session)
#         @login, @password, @session = login, password, session
#     end
    
#     def message
#         raise if password != '123'
    
#         session[:login] = login
#         session[:credits] ||= 1000
    
#         "#{login}, вы вошли в #{Time.now}"
#     end
# end