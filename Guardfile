guard :rspec, cmd: 'rspec' do
  watch(%r{^lib/(.+).rb$})      { |m| "spec/unit/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/(.+).rb$})     { |m| "spec/#{m[1]}.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('Gemfile')
end