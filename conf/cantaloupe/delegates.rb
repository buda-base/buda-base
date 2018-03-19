#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'open-uri'
require 'digest'
require 'dalli'
require "net/http"
require 'net/https'
require "uri"

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
    #         corresponding to the given identifier;
    #                   or Hash including `bucket` and `key` keys;
    #                   or nil if not found.
    #
    def self.get_object_key(identifier, context)

      #cache options and client
      options = { :namespace => "cantaloupe_cache", :compress => true }
      dc = Dalli::Client.new('localhost:11211', options)
      static='static/error.png'
      if(identifier != nil && identifier=~ /::/)
        item, *image = identifier.split(/::/)
        response = dc.get(item)
      else
        return static;
      end
      if(response!=nil)
        if (response=='non-public')
          return static;
        end
      else
        uri = URI.parse("http://purl.bdrc.io/query/Item_basicInfo")
        http = Net::HTTP.new(uri.host,uri.port)
        req = Net::HTTP::Post.new(uri.path)
        payload = {"R_RES" => item }
        req.set_form_data(payload)
        response = http.request(req).body.to_s
        dc.set(item, response)
      end      
      
      responsej = JSON.parse(response)
      if(responsej["results"].length>0)
        access= responsej["results"][0]["bindings"]["access"]["value"]
        if(access =='http://purl.bdrc.io/resource/AccessOpen')
          work= responsej["results"][0]["bindings"]["work"]["value"]
          workShort = work[29..-1]
          key=image[0].split(".").first
          s3= 'Works/'+(Digest::MD5.hexdigest workShort)[0..1]+"/"+workShort+"/images/"+workShort+"-"+key[0,key.length-4]+"/"+image[0]
        else
          #we should have an error key pointing to a 'restricted warning' image 
          dc.set(item, 'non-public')
          return static;
        end
      else
        return static;
      end
      return s3;
    end
  end 
end

#puts Cantaloupe::authorized?('bdr:I29329::I1KG150430315.jpg', 'full', 'operations', 'resulting_size','output_format', 'request_uri', 'request_headers', 'client_ip','cookies')
#puts Cantaloupe::AmazonS3Resolver::get_object_key('bdr:I29329::I1KG150430315.jpg', 'full')
