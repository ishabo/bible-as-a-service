module Bible
  # Testament class provides a way to filter terms
  # used to refer to old & new testament and standarise
  # references to each
  class Testament

    ALL = 'all'
    OLD = 'old'
    NEW = 'new'

    FULL_BIBLE = 'full_bible'
    OLD_TESTAMENT = 'old_testament'
    NEW_TESTAMENT = 'new_testament'

    def self.detect_testament testament
      return OLD_TESTAMENT if self.old_testament? testament
      return NEW_TESTAMENT if self.new_testament? testament
      FULL_BIBLE
    end

    def self.new_testament? testament
      %w(new new_testament new_covenant nt).include? testament
    end

    def self.everything? testament
      %w(all whole entire full_bible).include? testament
    end

    def self.old_testament? testament
      %w(old old_testament old_covenant ot).include? testament
    end

    def self.narrow_down_testament testament
      return NEW if self.new_testament? testament
      return OLD if self.old_testament? testament
      return ALL if self.everything? testament
    end
  end
end
