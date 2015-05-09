# Description:
# youtube me dawg
#
# Commands:
#   hubot youtube me <query> - Searches YouTube for the query and returns the video embed link.
module.exports = (robot) ->
  robot.respond /(youtube|yt)( me)? (.*)/i, (msg) ->
    key = process.env.HUBOT_BIZBOT_YOUTUBE_TOKEN
    query = msg.match[3]

    robot.http("https://www.googleapis.com/youtube/v3/search")
      .query({
        part: "snippet"
        orderBy: "relevance"
        key: key
        q: query,
        maxResults: 1
      })
      .get() (err, res, body) ->
        videos = JSON.parse(body)
        videos = videos.items

        unless videos?
          msg.send "No video results for \"#{query}\""
          return

        video  = msg.random videos

        msg.send 'https://www.youtube.com/watch?v=' + video.id.videoId
