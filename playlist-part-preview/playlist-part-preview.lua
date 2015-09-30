--- Plugin for viewing small pieces of long videos from your playlist
--- I.e. for 25 minute video you will see:
--- 02:00-02:20
--- 07:00-07:20
--- etc

-- defaults:
sample_duration = 20  -- time in seconds
first_position = 60 -- time of first sample
sample_step = 60 * 5 -- interval between samples
small_duration = 60 * 20 -- duration for small videos

final_backstep = 75 -- step from the end of video for final part preview
final_duration = 30

function descriptor()
   return {
      title = "Playlist part preview";
   }
end

function activate()
   actual_playlist=vlc.playlist.get("playlist",false).children
   new_playlist={}
   for i, v in pairs(actual_playlist) do
        localStart = 0
        localStep = 0
        if (v.duration < small_duration) then
               localStart = first_position
               localStep = sample_step
        else
               localStart = first_position * 2
               localStep = sample_step * 2       
        end
  
      for j=localStart,v.duration,localStep do
         new_title=v.name.."-"..j
                   
         table.insert(new_playlist, {path=v.path, title=new_title, name=new_title, 
          duration=v.duration, options={"start-time="..j, "stop-time="..(j+sample_duration)}})
      end
      
      -- adding final part
      finalPartStart = v.duration- final_backstep
      new_title=v.name.."- final"
      table.insert(new_playlist, {path=v.path, title=new_title, name=new_title, 
        duration=v.duration, options={"start-time="..finalPartStart, "stop-time="..(finalPartStart+final_duration)}})
   end
   vlc.playlist.clear()
   vlc.playlist.enqueue(new_playlist)
   vlc.deactivate()
end

function deactivate()
end