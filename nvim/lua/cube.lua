local M = {}

-- Weak perspective. Character cells are ~2:1 (taller than wide), so x is scaled by ASPECT.
local CAM = 8
local MARGIN = 0.12
local ASPECT = 2
local RADIUS = math.sqrt(3)
local AX_RATE, AY_RATE = 0.35, 0.35
local AX0, AY0 = 0.40, 0.35

local VERTS = {
  { -1, -1, -1 },
  { 1, -1, -1 },
  { 1, 1, -1 },
  { -1, 1, -1 },
  { -1, -1, 1 },
  { 1, -1, 1 },
  { 1, 1, 1 },
  { -1, 1, 1 },
}

-- CCW from outside. Each face's 4 edges are drawn iff the face is front-facing.
local FACES = {
  { 1, 4, 3, 2 }, -- -Z
  { 5, 6, 7, 8 }, -- +Z
  { 2, 3, 7, 6 }, -- +X
  { 1, 5, 8, 4 }, -- -X
  { 4, 8, 7, 3 }, -- +Y
  { 1, 2, 6, 5 }, -- -Y
}

local EDGES = {
  { 1, 2 },
  { 2, 3 },
  { 3, 4 },
  { 4, 1 },
  { 5, 6 },
  { 6, 7 },
  { 7, 8 },
  { 8, 5 },
  { 1, 5 },
  { 2, 6 },
  { 3, 7 },
  { 4, 8 },
}

M._debug = { verts = VERTS, edges = EDGES }

local uv = vim.uv or vim.loop
local generation = 0

function M._rotate(x, y, z, t)
  local ax = t * AX_RATE + AX0
  local ay = t * AY_RATE + AY0
  local cx, sx = math.cos(ax), math.sin(ax)
  local cy, sy = math.cos(ay), math.sin(ay)
  local y1 = y * cx - z * sx
  local z1 = y * sx + z * cx
  local x2 = x * cy + z1 * sy
  local z2 = -x * sy + z1 * cy
  return x2, y1, z2
end

function M._project(x, y, z, vw, vh)
  -- Sphere silhouette diameter R / sqrt(C^2-R^2), not the looser 1/(C-R) bound.
  local max_span = 2 * RADIUS / math.sqrt(CAM * CAM - RADIUS * RADIUS)
  local usable = 1 - MARGIN
  local scale = math.min((vw * usable) / (max_span * ASPECT), (vh * usable) / max_span)
  local w = 1 / (CAM - z)
  local px = x * w * scale * ASPECT + (vw - 1) * 0.5
  local py = -y * w * scale + (vh - 1) * 0.5
  return px, py
end

local function rotate_all(t)
  local pts = {}
  for i = 1, 8 do
    local v = VERTS[i]
    local x, y, z = M._rotate(v[1], v[2], v[3], t)
    pts[i] = { x, y, z }
  end
  return pts
end

local function face_front(pts, face)
  local a, b, c = pts[face[1]], pts[face[2]], pts[face[3]]
  local ux, uy, uz = b[1] - a[1], b[2] - a[2], b[3] - a[3]
  local vx, vy, vz = c[1] - a[1], c[2] - a[2], c[3] - a[3]
  local nx = uy * vz - uz * vy
  local ny = uz * vx - ux * vz
  local nz = ux * vy - uy * vx
  local viewx = -a[1]
  local viewy = -a[2]
  local viewz = CAM - a[3]
  return nx * viewx + ny * viewy + nz * viewz > 0
end

local function plot(grid, x, y, ch, w, h)
  if x < 0 or y < 0 or x >= w or y >= h then
    return
  end
  grid[y + 1][x + 1] = ch
end

local function cell_at(grid, x, y, w, h)
  if x < 0 or y < 0 or x >= w or y >= h then
    return " "
  end
  return grid[y + 1][x + 1]
end

-- ┌┐└┘ only at axis-aligned L-joins. Diagonal joints get ·.
local function corner_char(grid, x, y, w, h)
  local l = cell_at(grid, x - 1, y, w, h) == "─"
  local r = cell_at(grid, x + 1, y, w, h) == "─"
  local u = cell_at(grid, x, y - 1, w, h) == "│"
  local d = cell_at(grid, x, y + 1, w, h) == "│"
  if r and d and not l and not u then
    return "┌"
  end
  if l and d and not r and not u then
    return "┐"
  end
  if r and u and not l and not d then
    return "└"
  end
  if l and u and not r and not d then
    return "┘"
  end
  return "·"
end

-- Glyph from the step that landed on this cell, so shallow edges read as ─╲─ not a dash staircase.
local function step_char(moved_x, moved_y, diag)
  if moved_x and moved_y then
    return diag
  end
  if moved_x then
    return "─"
  end
  return "│"
end

local function draw_edge(grid, x0, y0, x1, y1, w, h)
  local dx = x1 - x0
  local dy = y1 - y0
  if dx == 0 and dy == 0 then
    return
  end
  local adx, ady = math.abs(dx), math.abs(dy)
  local sx = dx < 0 and -1 or 1
  local sy = dy < 0 and -1 or 1
  local diag = ((dx > 0) == (dy > 0)) and "╲" or "╱"
  if adx >= ady then
    local err = math.floor(adx / 2)
    local x, y = x0, y0
    plot(grid, x, y, step_char(true, err - ady < 0, diag), w, h)
    while x ~= x1 do
      x = x + sx
      local my = false
      err = err - ady
      if err < 0 then
        y = y + sy
        err = err + adx
        my = true
      end
      plot(grid, x, y, step_char(true, my, diag), w, h)
    end
  else
    local err = math.floor(ady / 2)
    local x, y = x0, y0
    plot(grid, x, y, step_char(err - adx < 0, true, diag), w, h)
    while y ~= y1 do
      y = y + sy
      local mx = false
      err = err - adx
      if err < 0 then
        x = x + sx
        err = err + ady
        mx = true
      end
      plot(grid, x, y, step_char(mx, true, diag), w, h)
    end
  end
end

function M.render(t, width, height)
  local grid = {}
  for y = 1, height do
    local row = {}
    for x = 1, width do
      row[x] = " "
    end
    grid[y] = row
  end

  local pts = rotate_all(t)
  local ix, iy = {}, {}
  for i = 1, 8 do
    local p = pts[i]
    local px, py = M._project(p[1], p[2], p[3], width, height)
    ix[i] = math.floor(px + 0.5)
    iy[i] = math.floor(py + 0.5)
  end

  local vis_vert = {}
  local edge_n = {}
  local edge_ab = {}
  for f = 1, 6 do
    local face = FACES[f]
    if face_front(pts, face) then
      for k = 1, 4 do
        vis_vert[face[k]] = true
        local a = face[k]
        local b = face[k % 4 + 1]
        local key = a < b and (a * 8 + b) or (b * 8 + a)
        edge_n[key] = (edge_n[key] or 0) + 1
        edge_ab[key] = { a, b }
      end
    end
  end
  -- Internals first, silhouette last so the 6-edge outline wins at overlaps.
  for pass = 2, 1, -1 do
    for key, n in pairs(edge_n) do
      if n == pass then
        local e = edge_ab[key]
        draw_edge(grid, ix[e[1]], iy[e[1]], ix[e[2]], iy[e[2]], width, height)
      end
    end
  end

  for i = 1, 8 do
    if vis_vert[i] then
      local x, y = ix[i], iy[i]
      if x >= 0 and y >= 0 and x < width and y < height then
        local ch = corner_char(grid, x, y, width, height)
        plot(grid, x, y, ch, width, height)
      end
    end
  end

  local lines = {}
  for y = 1, height do
    lines[y] = table.concat(grid[y])
  end
  return lines
end

function M.stop()
  generation = generation + 1
  local timer = M._timer
  M._timer = nil
  if timer then
    pcall(function()
      timer:stop()
      timer:close()
    end)
  end
end

function M.start(opts)
  opts = opts or {}
  M.stop()
  generation = generation + 1
  local gen = generation
  local fps = opts.fps or 10
  local width = opts.width or 32
  local height = opts.height or 16
  local on_frame = opts.on_frame
  local interval = math.max(1, math.floor(1000 / fps + 0.5))
  local t0 = uv.hrtime()
  local timer = uv.new_timer()
  M._timer = timer
  timer:start(
    0,
    interval,
    vim.schedule_wrap(function()
      if gen ~= generation or M._timer ~= timer or not on_frame then
        return
      end
      local t = (uv.hrtime() - t0) / 1e9
      on_frame(M.render(t, width, height))
    end)
  )
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("CubeStop", { clear = true }),
  callback = function()
    M.stop()
  end,
})

return M
