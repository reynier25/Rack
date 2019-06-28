require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params
  # attr_accessor :already_built_response

  # Setup the controller
  def initialize(req, res)
    @res = res
    @req = req
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    # res.set_header

    if already_built_response?
      raise "already rendered"
    else
        @res.set_header('Location', url)
        # @res.location = url
        @res.status = 302
        @already_built_response = true
    end
    
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # @res.set_header('Content-type', content_type)
    # @res.body = ([content])
    # @res.set_header('Body', content)
    # response.headers['Content-Type'] = 'text/html'
    #raise error if double render

    if already_built_response?
      raise "already rendered"
    else
        @res.set_header('Content-type', content_type)
        @res.write(content)
        @already_built_response = true
    end
    
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)

    contents = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")  
    h = ERB.new(contents).result(binding)
    # debugger
    render_content(h, 'text/html')

  end
  

  # method exposing a `Session` object
  def session
  
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)

  end
end

