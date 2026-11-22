function odirty -d "dirty, limited to the ObServe repos (observe-*, watch-tower*, outpost)"
    dirty -p 'observe*' -p 'watch-tower*' -p outpost $argv
end
