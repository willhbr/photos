require 'date'
require 'digest/sha1'


tools = {
  'E PZ 18-105mm F4 G OSS' => 'sony105',
  'ILCE-6500' => 'a6500',
  'ILCE-6000' => 'a6000',
  'FC7303' => 'mini2',
  'FC3582' => 'mini3',
  '30mm F1.4 DC DN | Contemporary 016' => 'sigma30',
  '----' => 'samyang12',
}

OUTPUT = '/posts'

Dir.chdir '/drafts'

inputs = Dir['*'].shuffle
done = 0
inputs.each do |path|
  done += 1
  hash = Digest::SHA1.hexdigest(path)[0..5]
  if Dir["#{OUTPUT}/*#{hash}*"].any?
    puts "skipping #{path}"
    next
  end
  start = Time.now
  exif = `identify -verbose '#{path}'`.lines.map(&:strip).map { |l| l.split(': ', 2) }.reject { |a| a.size < 2 }.to_h
  puts "Identified #{path} in #{Time.now - start} seconds"
  if fnum = exif["exif:FNumber"]
    aperture = eval(fnum + '.0').round(1).to_s.chomp('.0')
  else
    aperture = nil
  end
  shutter = eval((exif['exif:ExposureTime'] || 0).to_s + '.to_f')
  if shutter == 0
    shutter = nil
  elsif shutter < 1
    rec = 1 / shutter
    shutter = "1/#{rec.round}"
  else
    shutter = shutter.to_s.chomp('.0')
  end
  focal = eval(exif["exif:FocalLength"].to_s).to_s

  lens = exif['exif:LensModel']
  camera = exif['exif:Model']

  if l = tools[lens]
    lens = l
  end
  if l = tools[camera]
    camera = l
  end
  if camera == 'mini2' || camera == 'mini3'
    focal = nil
  end

  begin
    date = Date.parse((exif['xmp:CreateDate'] || exif['exif:DateTime']
                      ).gsub(':', '/')).strftime('%F')
  rescue Exception => ex
    puts ex
    puts "Error parsing date for #{path}"
    pp exif
    date = Date.today.strftime('%F')
  end

  ratio = nil
  width = exif['exif:PixelXDimension'].to_i
  height = exif['exif:PixelYDimension'].to_i
  ratio = "#{width}/#{height}"if width && height

  output = "#{date}-#{hash}.jpeg"
  body = """\
---
images:
  - file: #{output}
"""

  body += "    aperture: #{aperture}\n" if aperture
  body += "    shutter: #{shutter}\n" if shutter
  body += "    lens: #{lens}\n" if lens
  body += "    focal: #{focal}\n" if focal
  body += "    camera: #{camera}\n" if camera
  body += "    ratio: #{ratio}\n" if ratio
  body += '---'

  start = Time.now
  system 'convert', path, '-resize', "#{1200 * 1200}@", '-quality', '60', '-strip', "/photos/#{output}"
  File.write("#{OUTPUT}/#{date}-#{hash}.md", body)
  puts "Wrote #{path} in #{Time.now - start} seconds"
  puts "Done #{done} of #{inputs.size} (#{(done.to_f / inputs.size * 100).round(0)}%)"
end

