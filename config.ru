use Rack::Static, 
  :urls => ["/assets/img", "/assets/js", "/assets/css"],
  :root => "public"

map "/" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},File.open('public/index.html', File::RDONLY)]
  }
end

map "/caesar_cipher/new" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html','Cache-Control' => 'public, max-age=86400'},File.open('public/caesar_cipher/new.html', File::RDONLY)]
  }
end

map "/caesar_cipher/solve" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html','Cache-Control' => 'public, max-age=86400'},File.open('public/caesar_cipher/solve.html', File::RDONLY)]
  }
end

map "/polyalphabetic_cipher/new" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html','Cache-Control' => 'public, max-age=86400'},File.open('public/polyalphabetic_cipher/new.html', File::RDONLY)]
  }
end

map "/polyalphabetic_cipher/solve" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html','Cache-Control' => 'public, max-age=86400'},File.open('public/polyalphabetic_cipher/solve.html', File::RDONLY)]
  }
end