class NoteSerializer
  attr_accessor :note

  def initialize(note)
    @note = note
  end

  def serializable_hash
    {
      id: note.id,
      text: note.text,
      creatorName: User.find(note.creator_id).name,
      recipientName: User.find(note.recipient_id).name,
    }
  end

  def as_json
    serializable_hash.to_json
  end
end
