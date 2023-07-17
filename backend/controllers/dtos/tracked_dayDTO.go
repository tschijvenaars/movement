package dtos

type TrackedDayDTO struct {
	Uuid        string
	Day         int64
	Confirmed   bool
	ChoiceId    int64
	ChoiceText  string
	Validated   float64
	Unvalidated float64
	Missing     float64
}
