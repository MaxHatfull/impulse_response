module Physics
  class CollisionResolver
    HANDLERS = {
      [CircleCollider, CircleCollider] => Collisions::CircleCircle,
      [RectCollider, RectCollider] => Collisions::RectRect,
      [CircleCollider, RectCollider] => Collisions::CircleRect
    }.freeze

    def self.check(a, b, tag: nil)
      return nil unless b.matches_tag?(tag)

      handler = HANDLERS[[a.class, b.class]]

      if handler
        handler.check(a, b)
      elsif (handler = HANDLERS[[b.class, a.class]])
        result = handler.check(b, a)
        return nil unless result

        # Swap colliders back so a is collider_a
        Collision.new(
          collider_a: a,
          collider_b: b,
          penetration: result.penetration,
          normal: -result.normal,
          contact_point: result.contact_point
        )
      end
    end
  end
end
