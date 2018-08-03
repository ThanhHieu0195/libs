require_relative '/home/hieutct/syn/libs/ruby/query_libs.rb'
QueryLibs.new.init()

get '/check' do
  channel_key = params['channel']
  f = File.open("/home/hieutct/syn/libs/ruby/accomodation-api.json", "r")
  json = ''
  f.each_line do |line|
    json += line
  end
  f.close
  data_channel = JSON.parse(json)
  check_in = data_channel['checkin']
  if params['checkin'].present?
    check_in = params['checkin']
  end
  check_out = data_channel['checkout']
  if params['checkout'].present?
    check_out = params['checkout']
  end

  if channel_key == 'all'
    data_channel['channels'].each do |channel_key, channel_info|
      data = ApiPrice.new(channel_key).perform(check_in,
                                               check_out,
                                               channel_info, false)
      text = "excuting #{channel_key}"\
        "\n#{JSON.pretty_generate(data).to_s}\n"\
        "-------------------- -------------------- --------------------  \n"
      QueryLibs.get_model.write_file(text, 'channels/' + channel_key, 'w')
    end
  else
    channel_info = data_channel['channels'][channel_key]
    data = ApiPrice.new(channel_key).perform(check_in,
                                             check_out,
                                             channel_info, false)
  end
  {status: 200, data: data}.to_json
end