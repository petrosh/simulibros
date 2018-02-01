---
title: Calendar
permalink: /calendar
layout: default
---
{%
assign cal = site.data.calendar %}{%
for c in cal %}{%
	assign start = c.from | date: "%s" %}{%
	assign end = c.to | date: "%s" %}{%
	assign loops = end | minus: start | divided_by: 86400 | round %}{%
	for d in (0..loops) %}{%
		assign increment = d | times: 86400 %}{%
		assign day = start | plus: increment %}{%
		assign week_day = day | date: "%A" %}{%
		for e in c.events %}{%
			assign week_offset = e[1].week_offset | default: 0 %}{%
			assign week_jump = e[1].week_jump | default: 1 %}{%
			assign week = day | date: "%U" | minus: week_offset | modulo: week_jump %}{%
			if e[1].week_day == week_day and week == 0 %}
- {{ day | date: "%A %-d %B" }} {{ e[1].name }}{%
			endif %}{%
		endfor %}{%
	endfor %}{%
endfor %}
