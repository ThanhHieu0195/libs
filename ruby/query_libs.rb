
class QueryLibs
  BASE_URL = '/home/hieutct/syn/libs/logs'
  def init
    @@model = QueryLibs.new
  end

  def start
    write_file("------------- START - #{Time.new.to_i} ------------- \n")
    @query_time = 0
    @time_start = Time.new.to_f
    @logs = []
  end

  def end
    @logs.each  do |text|
      write_file(text)
    end
    write_file("------------- END ------------- \n")
    @query_time
  end

  def log(text='', log_compare_before = true)
    @time_end = Time.new.to_f
    time_log = @time_end - @time_start - @query_time
    @query_time = @time_end - @time_start
    time_log = @query_time unless log_compare_before
    text << ' - ' if text.present?
    text << "time excute: #{time_log} - #{Time.new} \n"
    @logs << text
  end

  def write_file(text, path_name='', type='a')
    if path_name.blank?
      path_name = 'query_libs.log'
    end
    file_name = "#{BASE_URL}/#{path_name}"
    File.open(file_name, type) do |file|
      file.write text
    end
  end

  def result(text)
    text = text.to_s
    file_name = "#{BASE_URL}/result_log.log"
    File.open(file_name, 'a') do |file|
      file.write text
    end
  end

  def self.get_model
    @@model
  end
end

QueryLibs.new.init