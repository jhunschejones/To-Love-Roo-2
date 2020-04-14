if User.where(email: ENV["ROO_EMAIL"]).size == 0
  User.create(name: "Roo", email: ENV["ROO_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
end

if User.where(email: ENV["JOSHUA_EMAIL"]).size == 0
  User.create(name: "Joshua", email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
end

joshua = User.where(email: ENV["JOSHUA_EMAIL"]).first
roo = User.where(email: ENV["ROO_EMAIL"]).first

if Note.count < 2
  Note.create(text: "The first note!", creator_id: joshua.id, recipient_id: roo.id)
  Note.create(text: "The second note!", creator_id: joshua.id, recipient_id: roo.id)
  Note.create(text: "A note sent back!", creator_id: roo.id, recipient_id: joshua.id)
end
