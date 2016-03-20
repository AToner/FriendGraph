class FriendGraph

  def initialize
    @friends = {}
  end

  def add_friend id
    @friends[id] = FriendNode.new id unless @friends.has_key? id
    @friends[id]
  end

  def friends
    @friends.keys
  end

  def relation_ship(friend_id_1, friend_id_2)
    friend_1 = add_friend(friend_id_1)
    friend_2 = add_friend(friend_id_2)

    friend_1.related_to friend_id_2
    friend_2.related_to friend_id_1
  end

  def get_friends(id)
    return unless @friends.include? id

    node_distance = Hash.new(-1)
    node_distance[id] = 0

    result = {}
    queue = []
    queue.push(@friends[id])

    until queue.empty?
      friend = queue.shift

      friend.friends.each do |friend_id|
        if node_distance[friend_id] == -1
          node_distance[friend_id] = node_distance[friend.friend_id] + 1
          queue.push @friends[friend_id]

          result_distance = node_distance[friend_id]
          result[result_distance] = [] unless result.include? result_distance
          result[result_distance].push friend_id
        end
      end

    end
    result
  end
end

class FriendNode

  attr_reader :friend_id

  def initialize(id)
    @friends = {}
    @friend_id = id
  end

  def related_to(id)
    return if id == @friend_id

    unless @friends.include? id
      @friends[id] = true
    end
  end

  def friends
    @friends.keys
  end
end

puts "******** TEST THE STUFF"

friend_graph = FriendGraph.new
friend_graph.relation_ship(1, 2)
friend_graph.relation_ship(1, 3)
friend_graph.relation_ship(2, 4)
friend_graph.relation_ship(2, 6)
friend_graph.relation_ship(4, 5)
friend_graph.add_friend(7)

expected_result = []

expected_result[1] = {
    1 => [2,3],
    2 => [4,6],
    3 => [5]
}

expected_result[2] = {
    1 => [1, 4,6],
    2 => [3, 5]
}

expected_result[3] = {
    1 => [1],
    2 => [2],
    3 => [4,6],
    4 => [5]
}

expected_result[4] = {
    1 => [2, 5],
    2 => [1, 6],
    3 => [3]
}

expected_result[5] = {
    1 => [4],
    2 => [2],
    3 => [1, 6],
    4 => [3]
}

expected_result[6] = {
    1 => [2],
    2 => [1, 4],
    3 => [3, 5]
}

expected_result[7] = {}

friend_graph.friends.each do |friend|
  expected = expected_result[friend]
  result = friend_graph.get_friends(friend)

  puts "*** #{friend}"
  puts expected.inspect
  puts result.inspect
  puts 'YAY!' if expected == result
end
