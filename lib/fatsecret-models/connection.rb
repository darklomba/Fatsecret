require 'cgi'

class String 
	def esc       
	  CGI.escape(self).gsub("%7E", "~").gsub("+", "%20") 
  end 
end

module FatSecret
  class Connection
    def initialize
      @config = FatSecret.configuration
      unless @config && @config && @config.api_secret
        raise RuntimeError, "One or more api_keys not set" 
      end
    end
    
    def search (method, expression = "", args = {})
      is_api_method method
      
      query = {:method => "#{method}s.search",
			         :search_expression => expression.esc}
			query.merge!(args)
		  api_get(query)
    end
    
    def get (method, id, args = {})
      is_api_method method
      
      query = {:method => "#{method}.get",
                "#{method}_id" => id}
      query.merge!(args)
      
      #add oauth token if it is defined to make it ready for more methods
      query[oauth_token] = @config.oauth_token if @config.oauth_token
      api_get(query)
    end
    
    private
    
      def is_api_method (method)
        unless @config.api_methods.include? method
          raise TypeError, "#{method} api_method not defined" 
        end
      end
      
      def api_get(query) 
	      params = {
	      	:format => 'json',
	        :oauth_consumer_key => @config.api_key, 
	        :oauth_nonce => Digest::MD5.hexdigest(rand(11).to_s), 
	        :oauth_signature_method => "HMAC-SHA1", 
	        :oauth_timestamp => Time.now.to_i, 
	        :oauth_version => "1.0", 
	      } 
	      params.merge!(query)
	      sorted_params = params.sort {|a, b| a.first.to_s <=> b.first.to_s} 
	      base = base_string("GET", sorted_params) 
	      http_params = http_params("GET", params) 
	      sig = sign(base).esc 
	      uri = uri_for(http_params, sig) 
	      results = JSON.parse(Net::HTTP.get(uri))
	    end 

	    def base_string(http_method, param_pairs) 
	      param_str = param_pairs.collect{|pair| "#{pair.first}=#{pair.last}"}.join('&') 
	      list = [http_method.esc, @config.api_url.esc, param_str.esc] 
	      list.join("&") 
	    end 

	    def http_params(method, args) 
	      pairs = args.sort {|a, b| a.first.to_s <=> b.first.to_s} 
	      list = [] 
	      pairs.inject(list) {|arr, pair| arr << "#{pair.first.to_s}=#{pair.last}"} 
	      list.join("&") 
	    end 

	    def sign(base, token='') 
	      digest = OpenSSL::Digest::Digest.new('sha1')
	      secret_token = "#{@config.api_secret.esc}&#{token.esc}"
	      base64 = Base64.encode64(OpenSSL::HMAC.digest(digest, secret_token, base)).gsub(/\n/, '') 
	    end 

	    def uri_for(params, signature) 
	      parts = params.split('&') 
	      parts << "oauth_signature=#{signature}" 
	      URI.parse("#{@config.api_url}?#{parts.join('&')}") 
	    end 
  end
end
