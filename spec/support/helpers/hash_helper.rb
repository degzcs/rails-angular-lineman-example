# Mokey patch to do a deep reject of an specific key
class Hash
  def deep_reject_keys!(*keys_to_remove)
    keys_to_remove.each do |key|
      keys.each {|k| delete(k) if k == key || self[k] == self[key] }

      values.each {|v| v.deep_reject_keys!(key) if v.is_a? Hash }
    end
    self
  end
end