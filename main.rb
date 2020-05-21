require 'socket'
server = TCPServer.new 8080

types = {
	'.html' => 'text/html',
	'.js' =>   'text/javascript',
	'.css' =>  'text/css',
	'.json' => 'application/json',
	'.png' =>  'image/png',
	'.jpg' =>  'image/jpg',
	'.gif' =>  'image/gif',
	'.svg' =>  'image/svg+xml',
	'.wav' =>  'audio/wav',
	'.mp4' =>  'video/mp4',
	'.woff' => 'application/font-woff',
	'.ttf' =>  'application/font-ttf',
	'.eot' =>  'application/vnd.ms-fontobject',
	'.otf' =>  'application/font-otf',
	'.txt' =>  'text/plain',
	'.wasm' => 'application/wasm'
}

public = Dir.entries("public").select {|f| !File.directory? f}
public = public.map { |file| "/#{file}" }

def send_file(session, file, mime)
	session.print "HTTP/1.1 200\r\n"

	session.print "Content-Type: #{mime || 'text/html'}\r\n"
	session.print "\r\n"
	session.print File.read("public/#{file}")
end

while session = server.accept
	request = session.gets
	path = request.split(' ')[1]
	ext = File.extname(path)
	mime = types["#{ext}"]
	
	if(path == '/')
		send_file(session, 'index.html', mime)
	elsif(public.include?(path))
		send_file(session, path, mime)
	else 
		send_file(session, '404.html', mime)
	end
  	session.close
end