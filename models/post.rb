class Post
  # TODO: Gather all code from all previous exercises
  # - reader and accessors
  # - initialize
  # - self.find
  # - self.all
  # - save
  # - destroy

  attr_reader :id, :title, :url, :votes
  attr_writer :title, :url, :votes

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @url = attributes[:url]
    @votes = attributes[:votes] || 0
  end

  def self.find(id)
    DB.results_as_hash = true
    result = DB.execute("SELECT id, title, url, votes FROM posts WHERE posts.id = ?", id.to_s)
    if result.empty?
      return nil
    else
      result = result[0]
      Post.new(id: result["id"], title: result["title"], url: result["url"], votes: result["votes"])
    end
  end

  def self.all
    DB.results_as_hash = true
    data = DB.execute(" SELECT * FROM posts")
    posts = []
    data.each do |result|
      posts << Post.new(id: result["id"], title: result["title"], url: result["url"], votes: result["votes"])
    end
    return posts
  end

  def destroy
    DB.execute("DELETE from posts where id=?", @id)
  end

  def save
    if @id.nil?
      # byebug
      # create new entry
      DB.execute("INSERT INTO posts (title, url, votes) VALUES (?, ?, ?)", @title.to_s, @url.to_s, @votes.to_s)
      @id = DB.last_insert_row_id
    else
      DB.execute("UPDATE posts SET title =?, url =?, votes =? WHERE id =?", @title.to_s, @url.to_s, @votes.to_s, @id)
    end
  end
end
