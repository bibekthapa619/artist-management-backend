class DateNotAfterValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        return if value.blank?
        max_date = options[:date] || Date.current 
        if value > max_date
            message = options[:message] || "can't be after #{max_date}"
            record.errors.add(attribute, message)
        end
    end
end