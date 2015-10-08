#!/usr/bin/ruby -w

$DMENU_ARGS = ARGV.join(' ')

class String
  def starts_with? prefix
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

def display prompt, *items
  result = %x{echo "#{items.join "\n"}" | dmenu #{$DMENU_ARGS} -p '#{prompt}'}
  if $? != 0
    exit
  end

  if block_given?
    yield result
  else
    return result
  end
end

def query_xrandr *args
  lines = %x{xrandr #{args.join ' '}}.split $/
  if block_given?
    yield lines
  else
    return lines
  end
end

def get_outputs
  query_xrandr '-q' do |lines|
    lines.delete_at 0
    lines.delete_if {|line| line.starts_with?(' ') || line.include?('disconnected')}
    lines.map! {|line| line.split[0]}
    if block_given?
      yield lines
    else
      return lines
    end
  end
end

def get_output_info output
  query_xrandr '-q' do |lines|
    puts lines.inspect
    output_found = false
    lines.delete_at 0
    lines.reject! do |line|
      if output_found
        if line.starts_with? ' '
          false
        else
          output_found = false
          true
        end
      else
        if line.starts_with? output
          output_found = true
          true
        else
          true
        end
      end
    end
    lines.map!{|line| line.split(' ').join(' ')}
    if block_given?
      yield lines
    else
      return lines
    end
  end
end


def main
  display 'output', get_outputs do |output|
    output = output.chomp("\n")
    get_output_info output do |info|
      resolutions = info.map {|line| line.split(' ')[0]}
      display "#{output} resolutions:", resolutions do |resolution|
        resolution = resolution.chomp("\n")
        pipe = IO.popen('xrandr | grep -e " connected [^(]" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/"')
        while (line = pipe.gets)
          active = line.chomp("\n")
        end

        query_xrandr '--output', active, '--off', '--output', output, '--mode', resolution
        %x{nitrogen --restore}
      end
    end
  end
end

main
