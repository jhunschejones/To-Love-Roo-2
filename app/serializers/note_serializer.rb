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
      createdOn: note.created_at.strftime("%m/%d/%Y"),
      order: note_order
    }
  end

  def as_json
    serializable_hash.to_json
  end

  private

  def note_order
    if Note.last.id == note.id
      'last'
    elsif Note.first.id == note.id
      'first'
    else
      nil
    end
  end
end
