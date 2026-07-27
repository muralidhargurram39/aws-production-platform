resource "aws_subnet" "public" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    index => cidr
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-${each.key + 1}"
      Type = "Public"
    }
  )
}

resource "aws_subnet" "private" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs :
    index => cidr
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-${each.key + 1}"
      Type = "Private"
    }
  )
}

resource "aws_subnet" "database" {
  for_each = {
    for index, cidr in var.database_subnet_cidrs :
    index => cidr
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-database-${each.key + 1}"
      Type = "Database"
    }
  )
}
