require "bundler"
Bundler.setup
Bundler.require

Dir.glob('**/*.coffee') do |f|
  path = f.chomp(File.extname(f))+".js"
  File.open(path, 'w') {|js| js.write(CoffeeScript.compile File.read(f)) }
end

use Rack::Static, 
  :urls => ["/assets/img", "/assets/js", "/assets/css"],
  :root => "public"

context = Object.new
template = Tilt.new("app/views/layouts/application_layout.html.erb")

map "/" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
      [template.render(context, title: "Home") do 
        Tilt.new("app/views/home/index.html").render(Object.new)
      end]
    ]
  }
end

map "/caesar_cipher/new" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
      [template.render(context, title: "Caesar Cipher | New") do 
        Tilt.new("app/views/caesar_cipher/new.html").render(Object.new)
      end]
    ]
  }
end

map "/caesar_cipher/solve" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
      [template.render(context, title: "Caesar Cipher | Solve") do 
        Tilt.new("app/views/caesar_cipher/solve.html").render(Object.new)
      end]
    ]
  }
end

map "/polyalphabetic_cipher/new" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
      [template.render(context, title: "Polyalphabetic | Create") do 
        Tilt.new("app/views/polyalphabetic_cipher/new.html").render(Object.new)
      end]
    ]
  }
end

map "/polyalphabetic_cipher/solve" do
  run lambda { |env|
    [200, {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
      [template.render(context, title: "Polyalphabetic | Solve") do 
        Tilt.new("app/views/polyalphabetic_cipher/solve.html").render(Object.new)
      end]
    ]
  }
end