require File.expand_path('../../lib/processor', __FILE__)

# Runner sets up Aggregator, Anonymizer (with anonymizing function) and Processor instances
# Runs the processing in the path directory and filters purchases of a certain type
module Runner
  def self.run(path, type, &anonymization_fnc)
    aggregator = Aggregator.new
    anonymizer = init_anonymizer(&anonymization_fnc)
    processor = Processor.new(aggregator, anonymizer, path)
    processor.process_user_files(type)
  end

  class << self
    private

    def init_anonymizer(&anonymize_fnc)
      Anonymizer.new(&anonymize_fnc)
    end
  end
end
