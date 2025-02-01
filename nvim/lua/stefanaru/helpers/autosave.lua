local M = {}

AUTOSAVE_MAX_INACTIVE_SECONDS = 5 * 60
AUTOSAVE_TIMER_RUNNING = false
AUTOSAVE_WRITE_ALL = true
AUTOSAVE_LAST_ACTIVITY_TIME = os.time()
AUTOSAVE_TIMER_ID = vim.loop.new_timer()

-- Compare last activity time recorded with current time
-- and check if it exceedes the threshold
local check_user_is_inactive = function()
	local current_time = os.time()
	local inactive_duration = current_time - AUTOSAVE_LAST_ACTIVITY_TIME
	local max_inactivity_seconds = AUTOSAVE_MAX_INACTIVE_SECONDS
	return inactive_duration > max_inactivity_seconds
end

-- Verify if any loaded buffer contains any unsaved changes
local check_has_unsaved_changes = function()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
			if modified then
				return true
			end
		end
	end
	return false
end

local write_changes = function()
	vim.api.nvim_cmd({ cmd = (AUTOSAVE_WRITE_ALL and "wa") or "w" }, {})
	-- Timer will be resumed when the user becomes active again
	vim.loop.timer_stop(AUTOSAVE_TIMER_ID)
	AUTOSAVE_TIMER_RUNNING = false
end

-- Executed every minute by the timer
local timer_callback = function()
	if check_user_is_inactive() == false then
		return
	end

	-- Check if there are changes to be written before writing
	-- Otherwise, the last-changed timestamp on the file will
	-- keep getting updated while the user is inactive
	if check_has_unsaved_changes() then
		write_changes()
	end
end

local start_timer = function()
	-- Check once every minute if the user has become inactive
	vim.loop.timer_start(AUTOSAVE_TIMER_ID, (60 * 1000), (60 * 1000), vim.schedule_wrap(timer_callback))
	AUTOSAVE_TIMER_RUNNING = true
end

M.update_last_activity = function()
	AUTOSAVE_LAST_ACTIVITY_TIME = os.time()

	if AUTOSAVE_TIMER_RUNNING == false then
		start_timer()
	end
end

-- This is the entry point
-- Every time the cursor is moved in normal mode,
-- update the time when the user has last been seen
vim.api.nvim_command(
	"autocmd InsertLeave,TextChanged * lua require('stefanaru.helpers.autosave').update_last_activity()"
)

return M
