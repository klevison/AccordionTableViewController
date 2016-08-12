Pod::Spec.new do |s|

  s.name             = "AccordionTableViewController"
  s.version          = "0.0.2"
  s.summary          = "Accordion UITableViewController"
  s.description      = <<-DESC
                       Swift version of https://github.com/klevison/KMAccordionTableViewController
                       DESC
  s.homepage         = "https://github.com/klevison/AccordionTableViewController"
  s.screenshots      = "http://dl.dropbox.com/u/378729/MBProgressHUD/1.png"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Klevison Matias" => "klevison@gmail.com" }
  s.source           = { :git => "https://github.com/klevison/AccordionTableViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/klevison'

  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = "Classes", "Classes/**/*.{swift}"
  s.resource_bundles = {
    'AccordionTableViewController' => ['Classes/**/*.{xib,png,nib}']
  }

end
