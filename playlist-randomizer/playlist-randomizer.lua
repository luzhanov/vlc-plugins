--- Plugin for playlist randomisation

function descriptor()
    return {
      title = "Playlist randomize";
   }
end

function activate()
   if (#vlc.playlist.get("playlist",false).children > 0) then
      if vlc.input.is_playing()==false then
         vlc.msg.info("[Playlist randomizer] playlist not empty, no playback, ready for randomizing")
         click_Randomize()
      else
         vlc.msg.info("[Playlist randomizer] playlist not empty, stopping actual playback, opening dialog box")
         vlc.playlist.stop()
         create_dialog()
      end
   else
      vlc.msg.info("[Playlist randomizer] empty playlist, deactivating extension")
      vlc.deactivate()
   end
end

function deactivate()
end

function close()
   vlc.deactivate()
end

function create_dialog()
   d = vlc.dialog("Playlist randomizer")
   button = d:add_button("Randomize playlist", click_Randomize,1,2,1,1)
end

function click_Randomize()
   if vlc.input.is_playing()==true then
      vlc.msg.info("[Playlist randomizer] dialog box opened, stopping actual playback???")
      vlc.playlist.stop()
   end
   vlc.msg.info("[Playlist randomizer] randomizing")
   vlc.playlist.sort('random')
   randomized_playlist=vlc.playlist.get("playlist",false).children
   new_playlist={}

   for i, v in pairs(randomized_playlist) do
      table.insert(new_playlist, {path=v.path, title=v.name, name=v.name, duration=v.duration})
   end

   vlc.playlist.clear()
   vlc.playlist.enqueue(new_playlist)
   vlc.msg.info("[Playlist randomizer] randomizing done, deactivating extension")
   vlc.deactivate()
end