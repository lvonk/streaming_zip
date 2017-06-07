require "sinatra"
require "sinatra/streaming"
require 'zip'

helpers Sinatra::Streaming

module Sinatra
  module Helpers
    class Stream
      def reopen(*)

      end

      def dup
        x = super
        x.extend(Sinatra::Streaming::Stream)
        x
      end
    end
  end
end

get '/' do
  %Q{<html><body><a href="/stream">Download streaming</a><br><a href="/buffer">Download with stringio</a></body></html>}
end
get '/stream' do
  attachment "files.zip"
  stream do |out|
    Zip::OutputStream.write_buffer(out) do |zos|
      zos.put_next_entry("foo1.txt")
      zos.write 'hello'

      zos.put_next_entry("foo2.txt")
      zos.write 'hello'
    end
  end
end

get '/buffer' do
  attachment "files-buffer.zip"
  string_io = StringIO.new
  stream do |out|
    result = Zip::OutputStream.write_buffer(string_io) do |zos|
      zos.put_next_entry("foo1.txt")
      zos.write 'hello'

      zos.put_next_entry("foo2.txt")
      zos.write 'hello'
    end
    out.write(result.string)
    out.flush
  end
end
