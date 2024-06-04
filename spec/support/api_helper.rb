


def api_hash(api_key, hash_time)
  Digest::SHA256.hexdigest(api_key + hash_time.to_s)
end

def api_key(sending_object, opts)
  return opts[:api_key] if opts[:api_key]
  
  return sending_object[:api_key] if sending_object && sending_object[:api_key]

  Settings.default.web_object.api_key
end



def headers(sending_object= nil, opts = {})
  
  hash_time = Time.now.to_i
  {
    "content-type": "application/json",
    "x-auth-time": opts[:auth_time].nil? ? Time.now.to_i : opts[:auth_time],
    "x-auth-digest": api_hash(api_key(sending_object, opts), hash_time),
    "x-secondlife-local-position": sending_object.position,
    "x-secondlife-local-rotation": "(0.000000, 0.000000, 0.000000, 1.000000)",
    "x-secondlife-local-velocity": "(0.000000, 0.000000, 0.000000)",
    "x-secondlife-object-key": sending_object.object_key,
    "x-secondlife-object-name": sending_object.object_name,
    "x-secondlife-owner-key": sending_object.owner_key,
    "x-secondlife-owner-name": sending_object.owner_name,
    "x-secondlife-region": sending_object.region + "(258816, 350976)",
    "x-secondlife-shard": "Production"
  }
end