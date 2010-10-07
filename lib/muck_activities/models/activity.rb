# include MuckActivities::Models::MuckActivity
require 'muck_comments'
module MuckActivities
  module Models
    module MuckActivity
      extend ActiveSupport::Concern
      
      included do
        
        include ::MuckComments::Models::MuckCommentable
        
        belongs_to :item, :polymorphic => true
        belongs_to :source, :polymorphic => true
        belongs_to :attachable, :polymorphic => true
        has_many :activity_feeds, :dependent => :destroy
      
        validates_presence_of :source

        scope :newer_than, lambda { |*args| where("activities.created_at > ?", args.first || DateTime.now) }
        scope :older_than, lambda { |*args| where("activities.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
        scope :by_newest, order("activities.created_at DESC")
        scope :by_oldest, order("activities.created_at ASC")
        scope :by_latest, order("activities.updated_at DESC") # Using this we can bring activites back to the top of the feed
        scope :after, lambda { |id| where("activities.id > ?", id) }
        scope :is_public, where("activities.is_public = true")
        scope :filter_by_template, lambda { |template| where("activities.template = ?", template) unless template.blank? }
        scope :created_by, lambda { |activity_object| where("activities.source_id = ? AND activities.source_type = ?", activity_object.id, activity_object.class.to_s) }
        scope :status_updates, where("activities.is_status_update = true")
        scope :by_item, lambda { |item| where("activities.item_id = ? AND activities.item_type = ?", item.id, item.class.to_s) unless item.blank? }
        
        attr_protected :created_at, :updated_at
        
        validate :check_template
      end

      def check_template
        errors.add_to_base(I18n.t('muck.activities.template_or_item_required')) if template.blank? && item.blank?
      end

      # Provides a template that can be used to render a view of this activity.
      # If 'template' is not specified when the object created then the item class
      # name will be used to generated a template
      def partial
        template || item.class.name.underscore
      end

      def has_comments?
        @has_comments ||= !self.comments.blank?
      end

      # Checks to see if the specified object can edit this activity.
      # Most likely check_object will be a user
      def can_edit?(check_object)
        if check_object.is_a?(User)
          return true if check(check_object, :source_id)
        else
          source == check_object
        end
        false
      end
      
    end

  end
end