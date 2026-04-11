local TweenUtils = {}

export type TweenInfoOption = number | TweenInfo | {
	Duration: number?,
	EasingStyle: Enum.EasingStyle?,
	EasingDirection: Enum.EasingDirection?,
	RepeatCount: number?,
	Reverses: boolean?,
	DelayTime: number?,

	time: number?,
	style: Enum.EasingStyle?,
	direction: Enum.EasingDirection?,
	count: number?,
	reverse: boolean?,
	delay: number?,
}

function TweenUtils.createInfo(option: TweenInfoOption?): TweenInfo
	if typeof(option) == "number" then
		return TweenInfo.new(option)
	elseif typeof(option) == "TweenInfo" then
		return option
	elseif typeof(option) == "table" then
		return TweenInfo.new(
			option.Duration or option.time or 1,
			option.EasingStyle or option.style or Enum.EasingStyle.Linear,
			option.EasingDirection or option.direction or Enum.EasingDirection.Out,
			option.RepeatCount or option.count or 0,
			option.Reverses or option.reverse or false,
			option.DelayTime or option.delay or 0
		)
	else
		return TweenInfo.new()
	end
end

return TweenUtils
