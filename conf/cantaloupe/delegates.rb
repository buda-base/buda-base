#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'open-uri'
require 'digest'
require 'dalli'

module Cantaloupe

  def self.authorized?(identifier, full_size, operations, resulting_size,
                       output_format, request_uri, request_headers, client_ip,
                       cookies)
    true
  end

  module AmazonS3Resolver

    ##
    # @param identifier [String] Image identifier
    # @param context [Hash] Context for this request
    # @return [String,Hash<String,Object>,nil] Object key of the image
    #					corresponding to the given identifier;
    #                   or Hash including `bucket` and `key` keys;
    #                   or nil if not found.
    #
    def self.get_object_key(identifier, context)

      #cache options and client
      options = { :namespace => "cantaloupe_cache", :compress => true }
      dc = Dalli::Client.new('localhost:11211', options)

      item, *image = identifier.split(/::/)
      response = dc.get(item)
      if(response=='non-public')
        return "";
      end
      if(response==nil)
        response = open('http://purl.bdrc.io/resource/templates?searchType=Item_basicInfo&R_RES='+item[4..-1]+'&jsonOut').read
      end
      
      access= JSON.parse(response.to_s)["rows"][0]["dataRow"]["access"].split("> ").last.split("<").first
      
      if(access =='AccessOpen')
        dc.set(item, response)
        work= JSON.parse(response.to_s)["rows"][0]["dataRow"]["work"].split("> ").last.split("<").first
        key=image[0].split(".").first        
        return 'Works/'+(Digest::MD5.hexdigest work)[0..1]+"/"+work+"/images/"+work+"-"+key[0,key.length-4]+"/"+image[0]     
      else
        #we should have an error key pointing to a 'restricted warning' image 
        dc.set(item, 'non-public')
        return "";
      end
    end

  end  

end

