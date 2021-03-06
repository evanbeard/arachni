=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni
module Modules

#
# Allowed HTTP methods recon module.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.1
#
# @see http://en.wikipedia.org/wiki/WebDAV
# @see http://www.webdav.org/specs/rfc4918.html
#
class AllowedMethods < Arachni::Module::Base

    include Arachni::Module::Utilities

    def prepare
        @@__ran ||= false
    end

    def run
        return if @@__ran

        print_status( "Checking..." )

        @http.request( URI( normalize_url( @page.url ) ).host, :method => :options ).on_complete {
            |res|
            __log_results( res )
        }
    end

    def clean_up
        @@__ran = true
    end

    def self.info
        {
            :name           => 'AllowedMethods',
            :description    => %q{Checks for supported HTTP methods.},
            :elements       => [ ],
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>',
            :version        => '0.1.1',
            :references     => {
            },
            :targets        => { 'Generic' => 'all' },
            :issue   => {
                :name        => %q{Allowed HTTP methods},
                :description => %q{The webserver claims that it supports the logged methods.},
                :tags        => [ 'http', 'methods', 'options' ],
                :cwe         => '',
                :severity    => Issue::Severity::INFORMATIONAL,
                :cvssv2       => '',
                :remedy_guidance    => '',
                :remedy_code => '',
            }
        }
    end

    def __log_results( res )

        methods = res.headers_hash['Allow']

        return if !methods || methods.empty?

        log_issue(
            :url          => res.effective_url,
            :method       => res.request.method.to_s.upcase,
            :regexp_match => methods,
            :elem         => Issue::Element::SERVER,
            :response     => res.body,
            :headers      => {
                :request    => res.request.headers,
                :response   => res.headers,
            }
        )

        # inform the user that we have a match
        print_ok( methods )
    end

end
end
end
