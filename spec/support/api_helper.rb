# frozen_string_literal: true

def api_hash(api_key, hash_time)
  Digest::SHA256.hexdigest(api_key + hash_time.to_s)
end

def api_key(sending_object, opts)
  return opts[:api_key] if opts[:api_key]

  return sending_object[:api_key] if sending_object && sending_object[:api_key]

  Settings.default.web_object.api_key
end

def headers(sending_object = nil, opts = {})
  hash_time = Time.now.to_i
  {
    'content-type': 'application/json',
    'x-auth-time': opts[:auth_time].nil? ? Time.now.to_i : opts[:auth_time],
    'x-auth-digest': api_hash(api_key(sending_object, opts), hash_time),
    'x-secondlife-local-position': pos_to_sl_pos(sending_object.position),
    'x-secondlife-local-rotation': '(0.000000, 0.000000, 0.000000, 1.000000)',
    'x-secondlife-local-velocity': '(0.000000, 0.000000, 0.000000)',
    'x-secondlife-object-key': opts[:object_key].nil? ? 
                    sending_object.object_key : opts[:object_key],
    'x-secondlife-object-name': sending_object.object_name,
    'x-secondlife-owner-key': sending_object.user.avatar_key,
    'x-secondlife-owner-name': sending_object.user.avatar_name,
    'x-secondlife-region': "#{sending_object.region}(258816, 350976)",
    'x-secondlife-shard': 'Production'
  }
end

def pos_to_sl_pos(pos_json)
  pos_hash = JSON.parse(pos_json).with_indifferent_access
  "(#{pos_hash[:x]}, #{pos_hash[:y]}, #{pos_hash[:z]})"
end
