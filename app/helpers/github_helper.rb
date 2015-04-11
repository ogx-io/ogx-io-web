module GithubHelper

  # require 'octokit'

  def github_auth_api
    Rails.application.secrets['github_auth_api']
  end

  def github_token_api
    Rails.application.secrets['github_token_api']
  end

  def github_client_id
    Rails.application.secrets['github_client_id']
  end

  def github_client_secret
    Rails.application.secrets['github_client_secret']
  end

  def github_redirect_uri
    github_params = { client_id: github_client_id,
                      redirect_uri: 'https://ogx.io/github_callback',
                      state: 'aabbccddee',
                      scope: 'user' }
    "#{github_auth_api}?#{github_params.to_query}"
  end

  # Github code is returned by github api through github callback
  # See users#auth_with_github and users#github_callback for more information
  def github_user_token(github_code)
    require 'net/http'
    require 'json'
    require 'uri'

    uri = URI(github_token_api)
    request = Net::HTTP::Post.new uri.path
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = { client_id: github_client_id,
                     client_secret: github_client_secret,
                     code: github_code }.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = :SSLv3
      http.request request
    end
    json = JSON.parse(response.body)
    return json['access_token']
  end

  # Used when user is signing up with github
  def set_session_github_token(token)
    session[:github_token] = token
  end

  # Will be cleared after return
  def session_github_token
    token = session[:github_token]
    # session[:github_token] = nil
    token
  end

  def user_info_for_token(token)
    client = ::Octokit::Client.new(access_token: token)
    user = client.user.to_hash
    return user.slice(:login, :avatar_url, :name, :company, :blog, :location, :email, :id)
  rescue ::Octokit::Unauthorized => e
    return nil
  end

  def github_acc_info_to_ogx_acc_info(ginfo)
    info = {}
    info[:name] = ginfo[:login]
    info[:email] = ginfo[:email]
    info[:nick] = ginfo[:name]
    info[:website] = ginfo[:blog]
    info[:city] = ginfo[:location]
    info[:avatar] = ginfo[:avatar_url]
    info[:github_id] = ginfo[:id]
    info[:github_user_name] = ginfo[:login]
    info
  end

  def update_user_with_translated_info_from_github(user, tinfo, save = true)
    user.name = tinfo[:name] if user.name.blank?
    user.email = tinfo[:email] if user.email.blank?
    user.nick = tinfo[:nick] if user.nick.blank?
    user.website = tinfo[:website] if user.website.blank?
    user.city = tinfo[:city] if user.city.blank?
    user.github_id = tinfo[:github_id]
    user.github_user_name = tinfo[:github_user_name]
    # user.avatar.url = tinfo[:avatar] if user.avatar.url.blank?
    user.save! if save
  end
end
