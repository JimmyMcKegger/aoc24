import Config

if Code.ensure_loaded?(Dotenv) and File.exists?(".env") do
  Dotenv.load()
end
