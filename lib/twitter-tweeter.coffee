# Send tweets

fs = require "fs"

class Tweeter
  constructor: (@robot, @twit) ->
    logoPath = __dirname + "/../img/zf-logo.png"
    @logo = fs.readFileSync logoPath, { encoding: "base64" }

  tweet: (tweet_data) ->
    return if not tweet_data.status?

    @twit.post "media/upload", { media_data: @logo }, (err, data, res) =>
      if err
        @robot.logger.error "[Tweeter] Error uploading ZF logo", err
        return

      metadata =
        media_id: data.media_id_string,
        alt_text:
          text: "Zend Framework"

      @twit.post "media/metadata/create", metadata, (err, data, res) =>
        if err
          @robot.logger.error "[Tweeter] Error uploading ZF logo metadata", err
          return

        params =
          status: tweet_data.status
          media_ids: [ metadata.media_id ]

        @twit.post "statuses/update", params, (err, data, res) =>
          return if not err
          @robot.logger.error "[Tweeter] Error posting status update", err

module.exports = Tweeter
