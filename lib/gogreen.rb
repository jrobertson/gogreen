#!/usr/bin/env ruby

# file: gogreen.rb

require 'rscript'
require 'dynarex'
require 'acronym'
require 'polyrex'


class GoGreenException < Exception
end

class GoGreen

  def initialize(alias_file, site=nil, subdomain=nil)

    buffer = RXFHelper.read(alias_file).first
    
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
      
      code2, args = RScript.new.read a

      begin
        eval(code2)
      rescue
        ($!).to_s[/^[^\n]+/].to_s
      end   
   
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

    [rec.to_dynarex.records, rec.conf]
  end
  
end

if $0 == __FILE__ then

  alias_file, alias_name, *job_args =  ARV

  gg = GoGreen.new alias_file
  gg.execute alias_name, job_args  

end