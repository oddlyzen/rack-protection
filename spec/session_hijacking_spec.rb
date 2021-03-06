require File.expand_path('../spec_helper.rb', __FILE__)

describe Rack::Protection::SessionHijacking do
  it_behaves_like "any rack application"

  it "accepts a session without changes to tracked parameters" do
    session = {:foo => :bar}
    get '/', {}, 'rack.session' => session
    get '/', {}, 'rack.session' => session
    session[:foo].should == :bar
  end

  it "denies requests with a changing User-Agent header" do
    session = {:foo => :bar}
    get '/', {}, 'rack.session' => session, 'HTTP_USER_AGENT' => 'a'
    get '/', {}, 'rack.session' => session, 'HTTP_USER_AGENT' => 'b'
    session.should be_empty
  end

  it "denies requests with a changing Accept-Encoding header" do
    session = {:foo => :bar}
    get '/', {}, 'rack.session' => session, 'HTTP_ACCEPT_ENCODING' => 'a'
    get '/', {}, 'rack.session' => session, 'HTTP_ACCEPT_ENCODING' => 'b'
    session.should be_empty
  end

  it "denies requests with a changing Accept-Language header" do
    session = {:foo => :bar}
    get '/', {}, 'rack.session' => session, 'HTTP_ACCEPT_LANGUAGE' => 'a'
    get '/', {}, 'rack.session' => session, 'HTTP_ACCEPT_LANGUAGE' => 'b'
    session.should be_empty
  end

  it "denies requests with a changing Version header"do
    session = {:foo => :bar}
    get '/', {}, 'rack.session' => session, 'HTTP_VERSION' => '1.0'
    get '/', {}, 'rack.session' => session, 'HTTP_VERSION' => '1.1'
    session.should be_empty
  end
end
