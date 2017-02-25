desc "Run those specs"
task :spec do
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    t.spec_files = FileList['spec/*_spec.rb']
  end
end


desc "Scrap"
task :scrap_lexicons do
  ar_letters = %w{أ ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي}

end