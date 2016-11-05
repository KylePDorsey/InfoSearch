class File
   def self.return_lines(path, n = 1)
     open(path) do |f|
        lines = []
        n.times do
          line = f.gets || break
          lines << line
        end
        lines
     end
  end
end
