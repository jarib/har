module HAR
  module Commentable
    def comment
      @data['comment'] || ''
    end
  end
end