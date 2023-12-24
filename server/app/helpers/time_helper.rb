module TimeHelper

  # @return DateTime string value
  # @example date: "2022-05-31", time: 1015, timezone: 'Asia/Kolkata'
  def self.to_datetime_with_offset(date, time, timezone)
    offset = Time.new.in_time_zone(timezone).formatted_offset
    to_datetime(date, time).change(:offset => offset).to_datetime.to_s
  end

  def self.to_datetime(date, time)
    year, month, day = date.split("-")
    hour = time / 100
    min = time % 100

    Time.new(year, month, day, hour, min)
  end

  # Convert 24 hour time format to 12 hour time format.
  # @param [Time, time_24hr_format] time in 24 hour format. eg. 2022-11-18 07:45:00 UTC
  # @return [String] time in 12 hour format with meridian indicator. eg. 2:50 PM
  def self.to_12hr_time_format_in_time_zone(time_in_24hr_format:, time_zone:, padding: nil)
    date_time_in_time_zone = time_in_24hr_format.in_time_zone(time_zone)
    padding_flag = padding || '-'

    date_time_in_time_zone.strftime("%#{padding_flag}I:%M %p")
  end
end
