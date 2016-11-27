Gem::Specification.new do |s|
  s.name        = "miniakka"
  s.version     = "0.0.1"
  s.platform    = "java"
  s.summary     = "Minimalistic wrapper for Akka."
  s.description = "Allows create actor routers with supervisor."
  s.authors     = ["Adrian Haczyk"]
  s.email       = "haczyslaw@gmail.com"

  s.files       = Dir["lib/**/*.rb", "lib/**/*.jar"]
  s.license     = "Apache-2.0"
end
