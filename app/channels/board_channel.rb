class BoardChannel < ApplicationCable::Channel
  def subscribed
    # どのチャンネルを購読するか指定する
    stream_from "board_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  #購読しているチャンネルにメッセージを配信する記載
  def speak(data)
    board_comment = BoardComment.create!(user_id: current_user.id, board_id: data['board_id'], content: data['message'])
    image = User.find(current_user.id).image
    # image部分については右記URLを参照（activestorageで取得したURLの表示）　actioncableurlhttps://shinkufencer.hateblo.jp/entry/2018/07/25/230537
    ActionCable.server.broadcast 'board_channel', {name: current_user.name, message: data['message'],image: Rails.application.routes.url_helpers.polymorphic_url(image)}
  end
end
