require "sinatra"
require "sinatra/streaming"
require 'zip'

helpers Sinatra::Streaming

get '/' do
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
