class Course::UsersController < Course::ModuleController
  load_and_authorize_resource :course_user, through: :course, parent: false
  before_action :authorize_show!, only: [:index]
  before_action :authorize_edit!, except: [:index, :create]
  before_action :ensure_unregistered_user, only: :create

  def index # :nodoc:
  end

  def create # :nodoc:
    @course_user.workflow_state = :approved if current_course_user && current_course_user.staff?
    if @course_user.save
      success = t('.success', role: t("course.users.role.#{@course_user.role}"))
      redirect_to course_path(@course), success: success
    else
      redirect_to course_users_path(@course), danger: @course_user.errors
    end
  end

  def update # :nodoc:
    @course_user.update(course_user_params)
    if @course_user.save
      success = t('.success', role: t("course.users.role.#{@course_user.role}"))
      redirect_to course_users_path(@course), success: success
    else
      redirect_to course_users_path(@course), danger: @course_user.errors
    end
  end

  def destroy # :nodoc:
    if @course_user.destroy
      success = t('.success', role: @course_user.role, email: @course_user.user.email)
      redirect_to course_users_path(@course), success: success
    else
      redirect_to course_users_path(@course), danger: @course_user.errors
    end
  end

  private

  def course_user_params # :nodoc:
    params.require(:course_user).permit(:user_id, :role, :name)
  end

  # Prevents access to this set of pages unless the user is a staff of the course.
  def authorize_show!
    authorize!(:show_users, current_course)
  end

  # Prevents access to this set of pages unless the user is a staff of the course.
  def authorize_edit!
    authorize!(:manage_users, current_course)
  end

  # Selects an appropriate redirect path depending on the current user. Users can be redirected
  # to this path if the operation they are attempting fails.
  def appropriate_redirect_path
    if can?(:manage_users, current_course)
      course_users_path(current_course)
    else
      course_path(current_course)
    end
  end

  def ensure_unregistered_user
    return unless current_course.course_users.exists?(user: @course_user.user)

    role = t("course.users.role.#{current_course_user.role}")
    message = t('course.users.new.already_registered', role: role)
    redirect_to appropriate_redirect_path, info: message
  end
end