module ActsAsParanoidAliases

  def self.included(base)
    base.extend(ClassMethods)

    def viewable?
      not deleted?
    end

    def hide
      update_attribute(:hidden_at, Time.now)
    end

    def hidden?
      deleted?
    end
  end

  module ClassMethods
    def with_hidden
      with_deleted
    end
  end

end