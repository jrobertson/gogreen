#!/usr/bin/env ruby

# file: gogreen.rb

require 'rscript'
require 'dynarex'
require 'acronym'
require 'polyrex'
require 'tempfile'



class Gg
  
  def self.call(argsx)    
    puts GoGreen.new(argsx.first).execute(argsx[1], argsx[2..-1]).to_s    
  end 
  
  def self.run(argsx)    
    puts GoGreen.new(argsx.first).execute(argsx[1], argsx[2..-1]).to_s    
  end      
  
end

class GoGreenException < Exception
end

class GoGreen

  def initialize(alias_file, site=nil, subdomain=nil, shell_execute: true, rsc: nil)
    super()

    @shell_execute, @rsc = shell_execute, rsc

    buffer = RXFHelper.read(alias_file, auto: false).first
    
    name = case buffer
    when /^<\?dynarex/
      @records = dxread(buffer)
    when /^<\?polyrex/ 
      @records, @conf = pxread(buffer, site, subdomain)
    else
      raise GoGreenException, 'alias file ' + alias_file + ' not recognised'
    end


  end

  def execute(alias_name, job_args=[])

    alias_found = @records[alias_name]
    return 'job not found' unless alias_found
    
    cmd = alias_found[:body][:command]
    cmd += ' ' + @conf if @conf
    
    if cmd[/^rcscript/] then

      a = cmd.sub(/^rcscript /,'').split + job_args.map do |x| 
        x.sub(/^["'](.*)["']$/,'\1') 
      end

      raw_code, args = RScript.new.read a
    
      begin

        if @shell_execute then
          
          a = raw_code.strip.lines
          a.unshift 'args = ' + args.inspect + "\n\n"
          lastline = a.pop
          a.push('puts ' + lastline)

          code2 = "$0 = 'gogreen'\n" + a.join.gsub('\"','"').gsub('\#','#')
          
          file = Tempfile.new('gogreen')        
          file.write(code2)
          file.close
          puts 'before ruby'
          r = `ruby #{file.path}`
          r.strip
          #pipe = IO.popen("ruby", "w")
          #pipe.write code2
          #pipe.close        
          
        else

          result = eval(raw_code)

        end
        
      rescue
        ($!).to_s[/^[^\n]+/].to_s
      end   
   
    elsif cmd[/^rsc/] and @rsc
      
      package, job, args = cmd.sub(/^rsc/,'').split + job_args
      @rsc.send(package.to_sym).send(job.to_sym, *args)
      
    else    
      `#{cmd} #{job_args.join(' ')}`
    end      
    
  end

  private

  def dxread(s)

    dx = Dynarex.new
    dx.parse s

    records = if dx.summary.include? :include then

      dx2 = Dynarex.new.parse dx.summary[:include]
      dx2.records.merge(dx.records)
    else    
      dx.records
    end

    records
  end

  def pxread(buffer, site, subdomain)

    px = Polyrex.new    

    px.parse buffer

    a = px.rxpath "site[label='#{site}']/subdomain[label='#{subdomain}']"

    raise GoGreenException, "site not found " if a.empty?

    rec = a.first

    r = [rec.to_dynarex.records, rec.conf]

    r
  end
  
end

if $0 == __FILE__ then

  alias_file, alias_name, *job_args =  ARV

  gg = GoGreen.new alias_file
  gg.execute alias_name, job_args  

end
